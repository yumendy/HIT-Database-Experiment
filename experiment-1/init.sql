use company;

-- 初始化数据库表结构

drop table if exists `employee`;
create table `employee`(
	`ename` varchar(32) not null comment '工作人员名字',
	`essn` char(18) not null comment '工作人员身份证号 主键',
	`address` varchar(256) not null comment '工作人员住址',
	`salary` decimal(8,2) not null comment '工作人员工资',
	`superssn` char(18) not null comment '工作人员直接领导的身份证号',
	`dno` int(11) not null comment '所属部门',
	primary key (`essn`)
) engine=InnoDB default charset=utf8 comment='员工表';

drop table if exists `department`;
create table `department` (
	`dname` varchar(32) not null comment '部门名',
	`dnember` int(11) not null comment '部门号',
	`mgrssn` char(18) not null comment '部门领导身份证号',
	`mgrstartdate` date not null comment '部门领导开始领导工作的日期',
	primary key (`dnember`)
) engine=InnoDB default charset=utf8 comment='部门表';

drop table if exists `project`;
create table `project` (
	`pname` varchar(32) not null comment '工程项目名',
	`pno` int(11) not null comment '工程项目号',
	`plocation` varchar(128) not null comment '工程项目所在地',
	`dno` int(11) not null comment '工程项目所属部门号',
	primary key (`pno`)
) engine=InnoDB default charset=utf8 comment='工程项目表';

drop table if exists `works_on`;
create table `works_on` (
	`essn` char(18) not null comment '工作人员身份证号',
	`pno` int(11) not null comment '工程项目号',
	`hours` float(5,2) not null comment '工作小时数',
	primary key (`essn`, `pno`)
) engine=InnoDB default charset=utf8 comment='工作表';

-- 初始化数据

-- 暂缺
